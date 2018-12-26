import React from 'react';
import Spinner from '../UI/Spinner/Spinner'
import Aux from '../../hoc/Aux/Aux'
import classes from './Logout.css'

const logout = () => {

	setTimeout(() =>{
		localStorage.setItem('isAuthenticated', null);
		localStorage.setItem('uid', null);
		window.location.replace("/auth/login/")
	}, 3000);
	return(
		<Aux>
			<Spinner />
			<div className={classes.Header}>
				Logging you out!
			</div>
		</Aux>
	);
}

export default logout;