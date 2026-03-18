type Props = {
	open: boolean
	setPage: (page: string) => void
	closeSidebar: () => void
}

function Sidebar({ open, setPage, closeSidebar }: Props) {
	const setPageAndClose = (page: string) => {
		setPage(page)
		closeSidebar()
	}
	return (
		<nav className={`sidebar ${open ? "open" : ""}`}>
			<h2>Menu</h2>
			<ul className="sidebar-options">
				<li onClick={() => setPageAndClose("home")}>Home</li>
				<li onClick={() => setPageAndClose("ingredients")}>Ingredients</li>
				<li onClick={() => setPageAndClose("recipes")}>Recipes</li>
				<li onClick={() => setPageAndClose("diets")}>Diets</li>
				<li onClick={() => setPageAndClose("expenses")}>Expenses</li>
			</ul>
			<ul className="sidebar-settings">
				<li onClick={() => setPageAndClose("settings")}>Settings</li>
			</ul>
		</nav>
	)
}

export default Sidebar