import React, { Component } from 'react';
import classes from './Login.css';
import Input from '../UI/Input/Input'; 
import Image from '../../assests/images/loginDog.png'
import { withRouter } from 'react-router-dom'
import Auth from '../../Firebase'
import Spinner from '../UI/Spinner/Spinner'
import Backdrop from '../UI/Backdrop/Backdrop'
import { validateEmail, validatePassword } from '../../Validity'

class Login extends Component {

	state = {
		isLoading: false,
		validity: {
			email: true,
			password: true
		},
		errorMessage: null
	}


	loginToDracker = (event) => {
		event.preventDefault();
		this.setState({isLoading: true, errorMessage: null})
		const email = event.target.email.value;
		const password = event.target.password.value;
		const validEmail = validateEmail(email);
		const validPass = validatePassword(password);

		if(!validEmail || !validPass) {
			this.setState({isLoading: false, validity: {email: validEmail, password: validPass}});
			return;
		}
		this.setState({validity: {email: validEmail, password: validPass}});
		Auth.signInWithEmailAndPassword(email, password).then(res => {
			const user = res.user
			const verified = user.emailVerified
			if(!verified) {
				const message = "Please verify your email address before proceeding."
				//Send email
				user.sendEmailVerification()
				this.setState({isLoading: false, errorMessage: message})
				return
			}
			const User = {
				name: user.displayName,
				email: user.email,
				phone: user.phoneNumber.slice(2),
				uid: user.uid
			}
			localStorage.setItem('isAuthenticated', true);
			localStorage.setItem('User', JSON.stringify(User));
			setTimeout(() => {
				window.location.replace("/")
			}, 3000);

		}).catch(err => {
			let message = null;
			switch(err.code){
				case "auth/wrong-password": 
					message = "The password is invalid. Please check the password provided."
					break;
				case "auth/user-not-found":
					message = "There is no user record corresponding to this email. The user doesn't exist or may have been deleted."
					break;
				default:
					message = "Something went wrong while trying to authenticate the user. Please check the email and password provided."
			}
			this.setState({isLoading: false, errorMessage: message})
		})
	}

	getForm = () => {
		return(
				<form className={classes.Form} onSubmit={this.loginToDracker}>
					<div className={classes.InputContainer}>
						<Input 
							valid = {this.state.validity.email}
							type = "email"
							label = "Email Address"
							id = "email"
							name = "email" 
							autoCapitalize = "off"
							required
							validation = {validateEmail}
							invalidMessage = "Please enter a valid email address."
						/>
						<Input 
							valid = {this.state.validity.password}
							type = "password"
							label = "Password"
							id = "password"
							name = "password" 
							autoCapitalize = "off"
							required
							validation = {validatePassword}
							invalidMessage = "Please enter a valid password."
						/>
						<button className={classes.Button} id="login-submit">
							Log In
						</button>
						<div className={classes.ErrorMessage}>
							{this.state.errorMessage}
						</div>
						<div className={classes.ForgotPassword}>
							<a className={classes.ForgotPasswordLink} href="/auth/account-recovery">
								I need help accessing my account
							</a>
						</div>
						<div className={classes.RegisterText}>
							Not a member yet?
						</div>
						<a className={classes.RegisterLink} href="/auth/register/">
							Register now for free
						</a>
					</div>
				</form>
		);
	}

	render() {
		return(
			<div className={classes.Login}>
				<div className={classes.Header}>
					Login to Dracker
				</div>
				<div className={classes.Container}>
					<section className={classes.Section1}>
						<img className={classes.Image} src={Image} alt="Login Page" />
						<div className={classes.Section1Header}>
							Transfer money at a click 
						</div>
						<div className={classes.Section1Description}>
							Send or receive money at a touch from anywhere. 
							Download the app and get on top of your finances.
						</div>
					</section>
					<section className={classes.Section2}>
						<div className={classes.Section2Header}>
							Welcome!
						</div>
						{this.getForm()}
					</section>
				</div>
				<Backdrop show = {this.state.isLoading}/>
				<div  
					style={
							{transform: 
								this.state.isLoading ? 
									'translateY(0)': 'translateY(-100%)'
							}
						   } 
						   className={classes.Loader}
					>
					<Spinner />
				</div>
			</div>
		);
	}
}

export default withRouter(Login);
