import { useState, useRef, useEffect } from "react"
import MessageBubble from "./MessageBubble"
import ChatInput from "./ChatInput"
import type { Message } from "../../types"

function Chat() {
	const [messages, setMessages] = useState<Message[]>([
		{
			id: crypto.randomUUID(),
			role: "assistant",
			content: "¡Hola! Soy tu asistente de cocina, dime en qué te puedo ayudar 👨‍🍳",
		}
	])
	const bottomRef = useRef<HTMLDivElement | null>(null)
	const [isSending, setIsSending] = useState(false)

	const sendMessage = async (text: string) => {
	if (!text.trim() || isSending) return
			const newMessage: Message = {
				id: crypto.randomUUID(),
				role: "user",
				content: text
			}
			setMessages((prev) => [...prev, newMessage])
			setIsSending(true)
			try {
				const res = await fetch("http://localhost:5678/webhook/api/message", {
					method: "POST",
					headers: {
						"Content-Type": "application/json"
					},
					body: JSON.stringify({
						message: text
					})
				})
				const data = await res.json()
				const aiMessage: Message = {
					id: crypto.randomUUID(),
					role: "assistant",
					content: data.output
				}
				setMessages((prev) => [...prev, aiMessage])
			} catch (error) {
				const errorMessage: Message = {
					id: crypto.randomUUID(),
					role: "assistant",
					content: "Error conectando con el asistente"
				}
				setMessages((prev) => [...prev, errorMessage])
			}
			setIsSending(false)
		}
	useEffect(() => {
		bottomRef.current?.scrollIntoView({
			behavior: "smooth"
		})
	}, [messages])
	return (
		<main className="chat">
		<div className="messages">
			{messages.map((msg) => {
				return (
					<MessageBubble
						key={msg.id}
						message={msg}
					/>
				)
			})}
			{isSending && (
			<MessageBubble
				message={{
				id: "thinking",
				role: "assistant",
				content: ""
				}}
			/>
			)}
  		<div ref={bottomRef}></div>
		</div>
			<ChatInput onSend={sendMessage} />
		</main>
	)
}

export default Chat