import React, { Component } from 'react';
import classes from './PasswordReset.css'
import Input from '../UI/Input/Input'
import { validateEmail } from '../../Validity'
import ProgressHeader from '../UI/ProgressHeader/ProgressHeader'
import Auth from '../../Firebase'

const steps = ['Enter your email address', 'Check your email']
const headers = ['Reset Your Password', 'Check your email']
const descriptions = ['To reset your password, just enter the email address you use to log into your Dracker account. If this is the email associated with your account, we will send a verification link to reset your password. This may be the email address you used when you first signed up for Dracker.',
'We\'ve sent a verification link to reset your password.'
]

class PasswordReset extends  Component{
	state = {
		validity: {
			email: true
		},
		selected: 0,
		email: null

	}

	continuePressed = (event) => {
		event.preventDefault()
		const email = event.target.email.value;
		if(!validateEmail(email)) {
			this.setState({validity: {email: false}})
			return 
		}
		Auth.sendPasswordResetEmail(email);
		this.setState({selected: 1, email: email})
	}

	emailFieldCompenent = () => {
		return(
			<form onSubmit={(event) => this.continuePressed(event)}>
				<Input 
					key="passwordReset_email"
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
				<button className={classes.Button}>
					Continue
				</button>
			</form>
		);
	}

	getEmail = (email) => {
		return(
			<div className={classes.Email}>
				{email}
			</div>
		);
	}

	render(){
		let compenent = null;
		let boxContent = null;
		if(this.state.selected === 0) {
			compenent = this.emailFieldCompenent()
			boxContent = (
					<div>
						<p>
							If you are having other problems accessing your account or with the app, <a className={classes.Link} href="https://github.com/raghavbhasin97/Dracker">we can help</a>.
						</p>
						<p>
							Don't have an account? <a className={classes.Link} href="/auth/register/">Register now</a>
						</p>
					</div>
			);
		} else {
			compenent = this.getEmail(this.state.email)
			boxContent = (
					<div>
						<h2 className={classes.RegisterHeader}>
							Didn't get an email?
						</h2>
						<p>
							Check your spam or junk folder and please 
							allow up to five minutes for the email to arrive.
							You might also check to see that your are using the 
							correct email address.
						</p>
					</div>
			);
		}

		return(
			<div className={classes.PasswordReset}>
				<section className={classes.Content}>
					<ProgressHeader 
						num = "2" 
						steps = {steps} 
						selected = {this.state.selected}
					/> 
					<h1 className={classes.Header}>
						{headers[this.state.selected]}
					</h1>
					<p className={classes.Description}>
						{descriptions[this.state.selected]}
					</p>
					{compenent}
					<div className={classes.RegisterBox}>
						{boxContent}
					</div>
				</section>
			</div>
		);
	}
}

export default PasswordReset;
