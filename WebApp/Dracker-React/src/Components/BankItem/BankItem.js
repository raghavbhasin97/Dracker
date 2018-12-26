import React from 'react';
import classes from './BankItem.css'
import { getLogo } from '../../Formattings'

const bankItem = (props) => {
	let defaultingItem = (
			<span className={classes.setDefault}>
				(
				<span className={classes.Link} onClick={props.setDefault}>
					Set
				</span>
				&nbsp;as default funding source)
			</span>
		);
	if(props.default) {
		defaultingItem = (
				<span className={classes.Default}>
					(Default funding source)
				</span>
		);
	}
	return(
		<div className ={classes.BankItem}>
			<div className={classes.Container}>
				<img className={classes.Logo} src={getLogo(props.institution)} alt={props.institution} />
			</div>
			<div className={classes.Container}>
				<span className={classes.Name}>
					{props.name} 
					<span>
						&nbsp;{defaultingItem}
					</span>
				</span>
			</div>
		</div>
	);
}

export default bankItem;
