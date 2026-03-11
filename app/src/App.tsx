import { useState, useEffect } from "react"
import Sidebar from "./components/Sidebar"
import Topbar from "./components/Topbar"
import Overlay from "./components/Overlay"
import Chat from "./components/Chat/Chat"
import Ingredients from "./components/Ingredients/Ingredients"

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
  const [page, setPage] = useState("home")
  return (
    <div className="app">

      <Sidebar open={sidebarOpen} setPage={setPage} />

      {sidebarOpen && (
        <Overlay close={() => setSidebarOpen(false)} />
      )}

      <Topbar
        toggleSidebar={() => setSidebarOpen(!sidebarOpen)}
        toggleTheme={toggleTheme}
      />
      {page === "home" && <Chat />}
      {page === "ingredients" && <Ingredients />}
      {page === "recipes" && <h1>Recipes</h1>}
      {page === "diets" && <h1>Diets</h1>}
      {page === "expenses" && <h1>Expenses</h1>}
      {page === "configs" && <h1>Configs</h1>}
    </div>
  )
}

export default App