import { useState } from "react"

type Props = {
  onSend: (text: string) => void
}

function ChatInput({ onSend }: Props) {

  const [text, setText] = useState("")

  const sendMessage = () => {

    if (!text.trim()) return

    onSend(text)

    setText("")
  }

  return (
    <div className="input-area">

      <input
        value={text}
        onChange={(e) => setText(e.target.value)}
        placeholder="Escribe un mensaje..."
        onKeyDown={(e) => {
          if (e.key === "Enter") sendMessage()
        }}
      />

      <button onClick={sendMessage}>
        Send
      </button>

    </div>
  )
}

export default ChatInput