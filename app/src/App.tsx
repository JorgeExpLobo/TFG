import { useState, useEffect } from "react"
import Sidebar from "./components/Sidebar"
import Topbar from "./components/Topbar"
import Overlay from "./components/Overlay"
import Chat from "./components/Chat/Chat"

import "./styles/layout.css"

function App() {

  const [theme, setTheme] = useState<"dark" | "light">(() => {
    return (localStorage.getItem("theme") as "dark" | "light") || "dark"
  })
  const [sidebarOpen, setSidebarOpen] = useState(false)

  useEffect(() => {
    document.body.className = theme
    localStorage.setItem("theme", theme)
  }, [theme])

  const toggleTheme = () => {
    setTheme(prev => prev === "dark" ? "light" : "dark")
  }
  return (
    <div className="app">

      <Sidebar open={sidebarOpen} />

      {sidebarOpen && (
        <Overlay close={() => setSidebarOpen(false)} />
      )}

      <Topbar
        toggleSidebar={() => setSidebarOpen(!sidebarOpen)}
        toggleTheme={toggleTheme}
      />

      <Chat />

    </div>
  )
}

export default App