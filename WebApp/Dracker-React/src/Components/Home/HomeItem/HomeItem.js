import React from 'react';
import classes from './HomeItem.css';
import Button from '../../UI/Button/Button'
import { formatDate, getProfile } from '../../../Formattings'



const homeItem = (props) => {
	const imageSrc = getProfile(props.uid)
	const time = formatDate(props.time)
	let header = null;
	let description = null;
	let settled = true;
	let moreItem = null
	let details = null;
	if(props.clicked) {
		settled = false;
		moreItem = (
			<Button clicked={props.clicked} info>
					More&nbsp;
					<div style={{fontSize: '24px'}}>
						•••
					</div>
			</Button>
		);
	} else {
		details = <span>&quot;{props.description}&quot;</span>
	}
	if(props.isDebt) {
		if(settled){
			header = "You settled a charge with " + props.name
		} else {
			header = "You owe " + props.name
		}
	
		description = (
				<div className={classes.DetailsContainer}>
					<div className={classes.SansBold}>
						{props.name}
					</div>
					<div>
						&nbsp;charged <strong>you</strong>
					</div>
					<div className={[classes.Amount, classes.Payed].join(' ')}>
						&nbsp;${parseFloat(props.amount).toFixed(2)}
					</div>
				</div>
		);

	} else {
		if(settled){
			header = props.name + " settled a charge with you"
		} else {
			header = props.name + " owes you"
		}
	
		description = (
				<div className={classes.DetailsContainer}>
					<div>
						<strong>You</strong> charged&nbsp;
					</div>
					<div className={classes.SansBold}>
						{props.name}
					</div>
					<div className={[classes.Amount, classes.Charge].join(' ')}>
						&nbsp;${parseFloat(props.amount).toFixed(2)}
					</div>
				</div>
		);
	}
	return (
		<div className={classes.HomeItem}>
			<div>
				<div className={classes.Heading}>
					{header}
				</div>
				<div className={classes.DetailsContainer}>
					<div className={classes.ImageContainer}>
						<img className={classes.Image} src={imageSrc} alt="Profile"/>
						<div className={classes.Handel}>
							@{props.phone}
						</div>
					</div>
					<div className={classes.DetailsItem}>
						<div className={classes.Description}>
							{description}
						</div>
						<div className={classes.Time}>
							{time}
						</div>
						<div className={classes.Details}>
							{details}
						</div>
					</div>
				</div>
			</div>
			<div className={classes.More}>
				{moreItem}
			</div>
		</div>
	)
}
export default homeItem;