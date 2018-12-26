import React from 'react';
import classes from "./Card.css"

const card = (props) => {
	let attachedClasses = [classes.Header, classes.RoundedTop]
	let baseClasses = [classes.Card, classes.Rounded]
	let container = [classes.Container]
	let symbol = null;
	if(props.credit) {
		attachedClasses.push(classes.Credit)
	} else if(props.debit) {
		attachedClasses.push(classes.Debit)
	} else if(props.total) {
		attachedClasses.push(classes.Total)
		baseClasses.push(classes.Bigger)
		container.push(classes.BiggerContainer)
		if(props.loss) {
			symbol = <span>&darr;</span>
		} else {
			symbol = <span>&uarr;</span>
		}
		if(props.amount === "0.00") {
			symbol = <span>&#8208;</span>
		}
	}

	return(
		<div className={baseClasses.join(' ')}>
		  	<div className={attachedClasses.join(' ')}>
		    	<h1>
		    		{props.amount}
		    	</h1>
		    	{symbol}
			</div>
			<div className={container.join(' ')}>
		    	<span>{props.title}</span>
		  	</div>
		</div>
	);
}

export default card;