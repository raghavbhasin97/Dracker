import React from 'react';
import classes from './Wallet.css';
import Card from '../Card/Card';
import HomeItem from '../Home/HomeItem/HomeItem'

const wallet = (props) => {
	const credit = parseFloat(props.credit)
	const debit = parseFloat(props.debit)
	const total = Math.abs(( credit - debit)).toFixed(2);
	let loss = false
	if(credit < debit) {
		loss =  true;
	}

	const settled = props.settled
	let feed = []
	for(let i = 0; i < settled.length; i++) {
		const item = settled[i];
		feed.push(
			<HomeItem 
				key = {'item_' + item.transaction_id + i}
				uid = {item.uid}
				name = {item.name}
			    amount = {item.amount}
			    time = {item.settelement_time}
			    phone = {item.phone}
			    isDebt = {item.is_debt}
			    description = {item.description}
			/>
		);
	}
	
	if(feed.length < 1) {
		feed = (
					<div className={classes.Empty}>
						<p>
							You haven't settled any debts yet, 
							or you owe nothing!
						</p>
					</div>
				);
	} 

	return(
		<div className={classes.Wallet}>
	    	<section>
			    <h1 className={classes.Heading}>
			      		Wallet
			    </h1>
			    <p className={classes.SubHeading}>
			      		A look at your virtual wallet. Take a look at
			      		your credits, debits and your expected net.
			      		Also take alook at the the settled transactions.

			    </p>
		    </section>
			<div className={classes.Items}>
				<Card title = "Credit" credit amount = {credit.toFixed(2)} />
				<Card title = "Total" total amount = {total} loss={loss}/>
				<Card title = "Debit" debit amount = {debit.toFixed(2)} />
			</div>
			<div className={classes.Content}>
				{feed}
			</div>
		</div>
	);
}

export default wallet;