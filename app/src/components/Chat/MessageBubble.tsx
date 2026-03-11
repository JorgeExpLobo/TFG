import type { Message } from "../../types"
import ReactMarkdown from "react-markdown"

type Props = {
  message: Message
}

function MessageBubble({ message }: Props) {
  const isThinking = message.id === "thinking"
  const base = `message ${message.role === "assistant" ? "assistant" : "user"}`
    return (
      <div className={`${base}`}>
        {isThinking ? (
          <span>
            Pensando<span className="thinking-dots"></span>
          </span>
        ) : (
          <ReactMarkdown>
            {message.content}
          </ReactMarkdown>
        )}
      </div>
    )
}

export default MessageBubble