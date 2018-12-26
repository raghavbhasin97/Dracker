import React from 'react';
import classes from './Button.css'

const button = (props) => {
	let attachedClasses = [classes.Button]
	if(props.success) {
		attachedClasses.push(classes.Success)
	} else if(props.danger) {
		attachedClasses.push(classes.Danger)
	} else if(props.info) {
		attachedClasses.push(classes.Info)
	}
	return (
		<button onClick={props.clicked} className={attachedClasses.join(' ')}>
			{props.children}
		</button>
	);
}
export default button;