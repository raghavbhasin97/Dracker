import React from 'react';
import Aux from "../../hoc/Aux/Aux";
import classes from './Layout.css'
import Toolbar from "../Navigation/Toolbar/Toolbar"

const layout = (props) => {
	return(
		<Aux>
			<Toolbar authentication={props.authentication}/>
			<main className={classes.Content}>
			 {props.children}
			</main>
      	</Aux>
	);
}

export default layout;
