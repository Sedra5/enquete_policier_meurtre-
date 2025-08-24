"use client";

import { useState, useEffect, useRef, useCallback } from 'react';

const WEBSOCKET_URL = 'ws://localhost:8765';

export interface Message {
  id: string;
  sender: 'user' | 'server' | 'system';
  type: string;
  content: React.ReactNode;
}

export const useCrimeSolverSocket = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [connectionStatus, setConnectionStatus] = useState('Connecting...');
  const websocket = useRef<WebSocket | null>(null);
  const reconnectTimeout = useRef<NodeJS.Timeout | null>(null);

  const connect = useCallback(() => {
    if (reconnectTimeout.current) {
        clearTimeout(reconnectTimeout.current);
    }
    if (websocket.current && websocket.current.readyState !== WebSocket.CLOSED) {
      return;
    }

    setConnectionStatus('Connecting...');
    websocket.current = new WebSocket(WEBSOCKET_URL);

    websocket.current.onopen = () => {
      setConnectionStatus('Connected');
    };

    websocket.current.onclose = () => {
      setConnectionStatus('Disconnected');
      if (!document.hidden) { // Don't show if tab is not active
        setMessages(prev => [...prev, {
            id: crypto.randomUUID(),
            sender: 'system',
            type: 'status',
            content: 'Connection lost. Attempting to reconnect in 5 seconds...'
        }]);
      }
      
      reconnectTimeout.current = setTimeout(connect, 5000);
    };

    websocket.current.onerror = () => {
      setConnectionStatus('Error');
       setMessages(prev => [...prev, {
        id: crypto.randomUUID(),
        sender: 'system',
        type: 'error',
        content: 'Failed to connect. Is the server running? Refresh to try again.'
      }]);
    };

    websocket.current.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        let serverMessage: React.ReactNode = '';
        let messageType = data.type || 'unknown';

        if (data.type.endsWith('_response') && data.data) {
          if (data.data.success) {
            serverMessage = <pre className="whitespace-pre-wrap font-code text-sm">{data.data.result}</pre>;
          } else {
            serverMessage = <span className="text-destructive">{data.data?.error || 'An unknown error occurred.'}</span>;
          }
        } else {
          switch (data.type) {
            case 'welcome':
              serverMessage = (
                <>
                  <h2 className="text-lg font-bold mb-1">{data.message}</h2>
                  <p>{data.instruction}</p>
                </>
              );
              break;
            case 'unknown_command':
              serverMessage = (
                <div className="space-y-1">
                  <p>❓ {data.message}</p>
                  <p>💡 {data.instruction}</p>
                  <p>📝 {data.example}</p>
                </div>
              );
              break;
            case 'pong':
              serverMessage = `🏓 Pong received!`;
              break;
            case 'error':
              serverMessage = <span className="text-destructive">Server Error: {data.message}</span>;
              break;
            default:
              serverMessage = <pre className="whitespace-pre-wrap font-code text-sm">{JSON.stringify(data, null, 2)}</pre>;
          }
        }

        setMessages(prev => [...prev, {
          id: crypto.randomUUID(),
          sender: 'server',
          type: messageType,
          content: serverMessage
        }]);

      } catch (error) {
        console.error('Failed to parse message:', event.data, error);
        setMessages(prev => [...prev, {
          id: crypto.randomUUID(),
          sender: 'server',
          type: 'parse_error',
          content: `Received unparsable message: ${event.data}`
        }]);
      }
    };
  }, []);

  useEffect(() => {
    connect();

    return () => {
      if (reconnectTimeout.current) {
        clearTimeout(reconnectTimeout.current);
      }
      if (websocket.current) {
        websocket.current.onclose = null; // prevent reconnect on component unmount
        websocket.current.close();
      }
    };
  }, [connect]);


  const sendMessage = (command: string) => {
    if (websocket.current && websocket.current.readyState === WebSocket.OPEN) {
      setMessages(prev => [...prev, {
        id: crypto.randomUUID(),
        sender: 'user',
        type: 'command',
        content: command
      }]);
      websocket.current.send(command.trim());
    } else {
      setMessages(prev => [...prev, {
        id: crypto.randomUUID(),
        sender: 'system',
        type: 'error',
        content: 'Not connected to the server.'
      }]);
    }
  };

  return { messages, connectionStatus, sendMessage };
};
