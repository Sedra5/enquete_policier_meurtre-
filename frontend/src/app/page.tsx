"use client";

import { useState, useRef, useEffect, FormEvent } from 'react';
import { SendHorizontal, User, Bot, ServerCrash } from 'lucide-react';
import { useCrimeSolverSocket, type Message } from '@/hooks/use-crime-solver-socket.tsx';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from '@/components/ui/badge';
import { cn } from '@/lib/utils';

export default function CrimeSolverPage() {
  const { messages, connectionStatus, sendMessage } = useCrimeSolverSocket();
  const [input, setInput] = useState('');
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (input.trim() && connectionStatus === 'Connected') {
      sendMessage(input.trim());
      setInput('');
    }
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const getStatusBadge = () => {
    switch (connectionStatus) {
      case 'Connected':
        return <Badge className="border-transparent bg-green-600 text-primary-foreground hover:bg-green-600/90">Connected</Badge>;
      case 'Connecting...':
        return <Badge variant="secondary">Connecting...</Badge>;
      case 'Disconnected':
        return <Badge variant="destructive">Disconnected</Badge>;
      case 'Error':
        return <Badge variant="destructive">Connection Error</Badge>;
      default:
        return <Badge variant="outline">{connectionStatus}</Badge>;
    }
  };
  
  const renderMessage = (msg: Message) => {
    const isUser = msg.sender === 'user';
    const isSystem = msg.sender === 'system';

    const avatar = isUser ? (
      <Avatar className="w-8 h-8">
        <AvatarFallback><User className="w-4 h-4" /></AvatarFallback>
      </Avatar>
    ) : (
      <Avatar className="w-8 h-8">
        <AvatarFallback><Bot className="w-4 h-4" /></AvatarFallback>
      </Avatar>
    );

    if (isSystem) {
        return (
            <div key={msg.id} className="flex justify-center items-center gap-2 my-4">
                <ServerCrash className="w-4 h-4 text-muted-foreground" />
                <p className="text-sm text-muted-foreground italic">{msg.content as string}</p>
            </div>
        )
    }

    return (
      <div key={msg.id} className={cn("flex items-start gap-4 my-6", isUser ? 'justify-end' : 'justify-start')}>
        {!isUser && avatar}
        <div className={cn(
          "max-w-2xl rounded-lg px-4 py-3 shadow-md",
          isUser ? 'bg-primary text-primary-foreground' : 'bg-card'
        )}>
          <div className="text-sm max-w-none">{msg.content}</div>
        </div>
        {isUser && avatar}
      </div>
    );
  };

  return (
    <div className="flex flex-col h-screen bg-background text-foreground font-body">
      <header className="flex items-center justify-between p-4 border-b border-border shadow-sm sticky top-0 bg-background/80 backdrop-blur-sm z-10">
        <h1 className="text-xl font-headline font-bold">Enquête policière</h1>
        {getStatusBadge()}
      </header>

      <ScrollArea className="flex-1">
        <div className="p-6 max-w-4xl mx-auto">
            {messages.map(renderMessage)}
            <div ref={messagesEndRef} />
        </div>
      </ScrollArea>

      <footer className="p-4 border-t border-border bg-background/80 backdrop-blur-sm sticky bottom-0">
        <form onSubmit={handleSubmit} className="flex items-center gap-4 max-w-4xl mx-auto">
          <Input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Type 'help' or any command..."
            className="flex-1 bg-card border-border focus:ring-accent focus:ring-2"
            autoComplete="off"
            disabled={connectionStatus !== 'Connected'}
          />
          <Button 
            type="submit"
            size="icon"
            className="bg-accent hover:bg-accent/90 text-accent-foreground"
            disabled={!input.trim() || connectionStatus !== 'Connected'}
            aria-label="Send command"
          >
            <SendHorizontal className="h-5 w-5" />
          </Button>
        </form>
         <p className="text-xs text-muted-foreground text-center mt-2">
            Status: {connectionStatus}
        </p>
      </footer>
    </div>
  );
}
