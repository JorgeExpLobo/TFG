type Props = {
	open: boolean
	setPage: (page: string) => void
}

function Sidebar({ open, setPage }: Props) {

	return (
		<nav className={`sidebar ${open ? "open" : ""}`}>
			<h2>Menu</h2>
			
<ul className="sidebar-options">
				<li onClick={() => setPage("home")}>Home</li>
				<li onClick={() => setPage("ingredients")}>Ingredients</li>
				<li onClick={() => setPage("diets")}>Diets</li>
				<li onClick={() => setPage("expenses")}>Expenses</li>
			</ul>
			<ul className="sidebar-settings">
				<li onClick={() => setPage("settings")}>Settings</li>
			</ul>

		</nav>
	)
}

export default Sidebar