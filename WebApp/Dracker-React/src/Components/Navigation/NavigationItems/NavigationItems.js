import React from 'react';
import classes from './NavigationItems.css'

const navItems = (props) => {
	return(
			<ul className={classes.NavigationItems}>
				{props.children}
			</ul>
	);
}
export default navItems;