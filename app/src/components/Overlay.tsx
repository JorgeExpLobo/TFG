type Props = {
  close: () => void
}

function Overlay({ close }: Props) {

  return (
    <div
      className="overlay"
      onClick={close}
    />
  )

}

export default Overlay