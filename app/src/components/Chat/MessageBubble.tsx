import type { Message } from "../../types"
import ReactMarkdown from "react-markdown"

type Props = {
  message: Message
}

function MessageBubble({ message }: Props) {

  
const base = `message ${message.role === "assistant" ? "assistant" : "user"}`
  return (
    <div className={`${base}`}>
      <ReactMarkdown>
        {message.content}
      </ReactMarkdown>
    </div>
  )


}

export default MessageBubble