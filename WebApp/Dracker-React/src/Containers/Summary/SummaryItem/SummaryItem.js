import React from 'react';
import classes from './SummaryItem.css';
import Button from '../../../Components/UI/Button/Button'
import { getProfile } from '../../../Formattings'

const homeItem = (props) => {
	const imageSrc = getProfile(props.uid);
	const amount = parseFloat(props.amount).toFixed(2)
	let amountContainer = (
							<div className={classes.Charge}>
								<strong>
									${Math.abs(amount)} &uarr;
								</strong>
							</div>
						);
	if(amount < 0) {
		amountContainer = (
							<div className={classes.Payed}>
								<strong>
									${Math.abs(amount)} &darr;
								</strong>
							</div>
						);
	}
	return (
		<div className={classes.SummaryItem}>
			<div className={classes.DetailsContainer}>
				<div className={classes.ImageContainer}>
					<img className={classes.Image} src={imageSrc} alt="Profile"/>
				</div>
				<div className={classes.DetailsItem}>
					<div className={classes.Description}>
						{props.name}
					</div>
					<div className={classes.Time}>
						@{props.phone}
					</div>
				</div>
			</div>
			<div className={classes.Amount}>
				{amountContainer}
			</div>
			<div className={classes.More}>
				<Button clicked={props.clicked} info>
						More&nbsp;
						<div style={{fontSize: '24px'}}>
							•••
						</div>
				</Button>
			</div>
		</div>
	)
}
export default homeItem;