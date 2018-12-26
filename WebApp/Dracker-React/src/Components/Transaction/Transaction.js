import React from 'react';
import classes from './Transaction.css';
import { withRouter } from 'react-router-dom'
import { formatPhone, getTransactionImage } from '../../Formattings'

function goBack(props) {
	props.history.goBack();
}

const transaction = (props) => {
	const item = props.item
	const imageUrl = getTransactionImage(item.tagged_image)
	let header = null;
	if(item.is_debt) {
		header = "You owe " + item.name
	} else {
		header = item.name + " owes you"
	}
	return(
			<div className={classes.Transaction}>
	      		<div className={classes.Container}>
	      			<button className={classes.Back} onClick={() => goBack(props)}> 
		      			&#8249;
		      		</button>
	      			<div className={classes.Details}>
	      				<div className={classes.HalfScreen}>
	      					<img className={classes.Image} src={imageUrl} alt="Transaction"/>
	      				</div>
	      				<div className={classes.HalfScreen}>
	      					<div className={classes.Right}>
		      					<div className={classes.Description}>
		      						{header}
		      					</div>
	      					</div>
	      					<div className={classes.RightAuto}>
		      					<div>
		      						Transaction ID: <strong>
		      										#{item.transaction_id}
		      									</strong>
		      					</div>
		      					<div>
		      						Amount: <strong>
		      									<span className={item.is_debt ? classes.Payed : classes.Charge}>
		      										${item.amount}
		      									</span>
		      								</strong>
		      					</div>
		      					<div>
		      						Description: <strong>
		      										{item.description}
		      									 </strong>
		      					</div>
		      					<div>
		      						Phone: <strong>
		      									+1 {formatPhone(item.phone)}
		      								</strong>
		      					</div>
	      					</div>
	      				</div>
	      			</div>
	      		</div>
	      	</div>
	);
}

export default withRouter(transaction);