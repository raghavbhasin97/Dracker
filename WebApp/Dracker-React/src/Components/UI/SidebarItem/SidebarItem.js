import React from 'react';
import classes from './SidebarItem.css';

const sidebarItem = (props) => {
	return (
		<div className={classes.SidebarItem}>
			<div className={classes.ImageDiv}>
				<img className={classes.Image} src={props.image} alt="Sidebar Item"/>
			</div>
			<h2 className={classes.Header}>
				{props.header}
			</h2>
			<div className={classes.Description}>
				{props.description}
			</div>
		</div>
	);
}

export default sidebarItem;