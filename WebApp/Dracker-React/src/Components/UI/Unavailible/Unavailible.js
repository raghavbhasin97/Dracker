import React from 'react';
import classes from './Unavailible.css';
import Image from '../../../assests/images/money.png'

const unavailible = (props) => (
	<div className={classes.Unavailible}>
		<img src={Image} alt="Unavailible" width="170"/>
		<br />
		<span>
			{props.text}
		</span>
	</div>
);


export default unavailible;
