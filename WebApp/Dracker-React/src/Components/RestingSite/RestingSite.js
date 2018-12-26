import React from 'react';
import classes from './RestingSite.css'
import Image from '../../assests/images/screen.png'
import { withRouter } from 'react-router-dom'

function loginHandler(props) {
	props.history.push('/auth/login/');
}

function registerHandler(props) {
	props.history.push('/auth/register/')
}

const rest = (props) => {
	return(
		<div className={classes.RestingSite}>
			<div className={classes.Container}>
				<img className={classes.Image} src={Image} alt="dracker" />
				<div className={classes.Content}>
					<h1 className={classes.CHeader}>
						Send money
						<br />
						Receive money and
						<br />
						track your debt
						<div className={classes.ButtonsContainer}>
							<div className={classes.Button} onClick={() => loginHandler(props)}>
								Login
							</div>
							<div className={classes.Button} onClick={() => registerHandler(props)}>
								Register
							</div>
						</div>
					</h1>
				</div>
			</div>
		</div>
	);
}

export default withRouter(rest);