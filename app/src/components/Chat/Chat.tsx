import { useState, useRef, useEffect } from "react"
import MessageBubble from "./MessageBubble"
import ChatInput from "./ChatInput"
import type { Message } from "../../types"

function Chat() {

  const [messages, setMessages] = useState<Message[]>([])

  const bottomRef = useRef<HTMLDivElement | null>(null)

  const sendMessage = (text: string) => {

    const newMessage: Message = {
      id: crypto.randomUUID(),
      role: "user",
      content: text
    }

    setMessages((prev) => [...prev, newMessage])

    simulateAI(text)
  }

  const simulateAI = (text: string) => {

    setTimeout(() => {

      const aiMessage: Message = {
        id: crypto.randomUUID(),
        role: "assistant",
        content: "Respuesta simulada de IA a: " + text
      }

      setMessages((prev) => [...prev, aiMessage])

    }, 1000)

  }

  useEffect(() => {

    bottomRef.current?.scrollIntoView({
      behavior: "smooth"
    })

  }, [messages])

  return (

    <main className="chat">

      <div className="messages">

        {messages.map((msg) => (
          <MessageBubble key={msg.id} message={msg} />
        ))}

        <div ref={bottomRef}></div>

      </div>

      <ChatInput onSend={sendMessage} />

    </main>

  )
}

export default Chat