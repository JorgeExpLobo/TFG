import type { Message } from "../../types"

type Props = {
  message: Message
}

function MessageBubble({ message }: Props) {

  return (
    <div className={`message ${message.role}`}>
      {message.content}
    </div>
  )

}

export default MessageBubble