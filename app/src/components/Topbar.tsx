type Props = {
  toggleSidebar: () => void
  toggleTheme: () => void
}

function Topbar({ toggleSidebar, toggleTheme }: Props) {

  return (
    <header className="topbar">

      <button onClick={toggleSidebar}>
        ☰
      </button>

      <div className="right-buttons">

        <button onClick={toggleTheme}>
          🌙
        </button>

        <button>
          👤
        </button>

      </div>

    </header>
  )
}

export default Topbar