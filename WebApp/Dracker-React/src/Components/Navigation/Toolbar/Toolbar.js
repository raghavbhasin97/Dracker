import React from 'react';
import classes from './Toolbar.css'
import Logo from '../../Logo/Logo';
import NavigationItems from '../NavigationItems/NavigationItems'
import NavItem from '../NavigationItems/NavigationItem/NavigationItem'
import Aux from "../../../hoc/Aux/Aux"

const toolbar = (props) => {

	let items = (
		<Aux>
			<NavItem link="/">Dashboard</NavItem>
			<NavItem link="/wallet/">Wallet</NavItem>
			<NavItem link="/summary/">Summary</NavItem>
			<NavItem link="/profile/">Profile</NavItem>
			<NavItem link="/auth/logout/">Logout</NavItem>
		</Aux>
	);
	if(props.authentication) {
		items = (
			<Aux>
				<NavItem link="/auth/login/">Login</NavItem>
				<NavItem link="/auth/register/">Register</NavItem>
			</Aux>
		);
	}

	return(
		<header className={classes.Toolbar}>
			<Logo />
			<nav>
				<NavigationItems>
					{items}
				</NavigationItems>
			</nav>
		</header>
	);
}
	

export default toolbar;