import React from 'react';
import classes from './SummaryDetailItem.css'
import { formatDate } from '../../../Formattings'

const summaryDetailItem = (props) => {
	let amountClasses = [classes.Amount]
	if(props.pending) {
		if(props.isDebt) {
			amountClasses.push(classes.Pay)
		} else {
			amountClasses.push(classes.Charge)
		}
	} else {
		amountClasses.push(classes.Settled)
	}
	return(
		<div className={classes.SummaryDetailItem}>
			<div className={classes.Container}>
				<div className={classes.DetailsItem}>
					<div className={classes.Description}>
						{props.description}
					</div>
					<div className={classes.Time}>
						Created on {formatDate(props.time)}
					</div>
				</div>
			</div>
			<div className={amountClasses.join(' ')}>
				${props.amount}
			</div>
		</div>
	);
}

export default summaryDetailItem;