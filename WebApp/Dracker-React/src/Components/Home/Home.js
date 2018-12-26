import React from 'react';
import classes from './Home.css'
import HomeItem from "./HomeItem/HomeItem"
import { withRouter } from 'react-router-dom'

function loadTransaction(props, transaction) {
	const path = props.match.path + "transaction/" + transaction.transaction_id + "/";
	props.history.push(path);
}

const home = (props) => {
	const unsettled = props.unsettled
	let feed = []
	for(let i = 0; i < unsettled.length; i++) {
		const item = unsettled[i];
		feed.push(
			<HomeItem 
				key = {'item_' + item.transaction_id}
				uid = {item.uid}
				name = {item.name}
			    amount = {item.amount}
			    time = {item.time}
			    phone = {item.phone}
			    isDebt = {item.is_debt}
			    clicked = {() => loadTransaction(props, item)}
			/>
		);
	}
	if(feed.length < 1) {
		feed = (
					<div className={classes.Empty}>
						<p>
							You have no pending transactions. You have either
						</p>
					</div>
				);
	} 

	return (
	    <div className={classes.Home}>
	    	<div className={classes.Container}>
	    		<section>
			    	<h1 className={classes.Heading}>
			      		Home
			      	</h1>
			      	<p className={classes.SubHeading}>
			      		A look at your recent transactions. 
			      		This gives you a look at all your pending 
			      		transaction. It also gives you a look at 
			      		transactions that you are owed and let's you 
			      		stay on top of everything.
			      	</p>
		      	</section>
		      	{feed}
	      	</div>
	    </div>
    );
}

export default withRouter(home);
