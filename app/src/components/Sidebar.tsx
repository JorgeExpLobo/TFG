type Props = {
  open: boolean
}

function Sidebar({ open }: Props) {

  return (
    <nav className={`sidebar ${open ? "open" : ""}`}>

      <h2>Menu</h2>

      <ul>
        <li>Home</li>
        <li>Ingredients</li>
        <li>Diets</li>
        <li>Expenses</li>
        <li>Configs</li>
      </ul>

    </nav>
  )
}

export default Sidebar