import React, { Component } from 'react';
import classes from './UpdatePassword.css'
import Input from '../UI/Input/Input'
import { validatePassword } from '../../Validity'
import ProgressHeader from '../UI/ProgressHeader/ProgressHeader'
import { withRouter } from 'react-router-dom'
import { getIdentifier } from '../../Formattings'
import Invalid from '../UI/Unavailible/Unavailible'
import Spinner from '../UI/Spinner/Spinner'
import Backdrop from '../UI/Backdrop/Backdrop'
import Auth from '../../Firebase'
import Aux from '../../hoc/Aux/Aux'


const steps = ['Enter your password', 'Enter new password', 'Password reset successful']
const headers = ['Enter Your Current Password', 'Reset Your Password', 'Reset Successful']
const descriptions = [
'Please confirm your current password, If that is correct, you will be allowed to type in your new password.',
'To set a new password, just enter it below. If this password is valid, we will reset your password. You can then use this password to log in to Dracker in the future.',
'You have successfully set up a new password.'
]

class UpdatePassword extends  Component{


	constructor(props){
		super(props)
		const expectedSession = localStorage.getItem('session')
		const currentSession = getIdentifier(this.props.location.pathname)
		this.state = {
			validity: {
				password: true
			},
			selected: 0,
			validSession: (currentSession === expectedSession),
			isLoading: false,
			errorMessage: null
		}
	}

	continuePressed = (event) => {
		this.setState({isLoading: true, errorMessage:null, validity: {password: true}})
		event.preventDefault()
		const password = event.target.password.value;
		if(!validatePassword(password)) {
			this.setState({validity: {password: false}, isLoading: false})
			return 
		}
		this.setState({validity: {password: true}});

		if(this.state.selected === 0) {
			Auth.signInWithEmailAndPassword(this.props.email, password).then(res =>{
				this.setState({isLoading: false, selected: 1})
			}).catch(err =>{
				this.setState({isLoading: false, errorMessage: 'The provided password doesn\'t match with our records. Please check the password provided.'})
			})
			
		} else if(this.state.selected === 1) {
			const user = Auth.currentUser
			user.updatePassword(password).then(res =>{
				this.setState({isLoading: false, selected: 2})
			}).catch(err =>{
				this.setState({isLoading: false, errorMessage: 'The password is invalid. Please check the password provided.'})
			})
		}
	}


	passwordFieldCompenent = () => {
		return(
			<form onSubmit={(event) => this.continuePressed(event)}>
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
				<button className={classes.Button}>
					Continue
				</button>
				<div className={classes.ErrorMessage}>
					{this.state.errorMessage}
				</div>
			</form>
		);
	}

	render(){
		let view = <Invalid text="This password update session is invalid or
							has expired. Please go to profile and start over." />
		if(this.state.validSession) {
			let compenent = null;
			let boxContent = null;
			if(this.state.selected < 2 ) {
				let boxText = "Once you confirm your password, you will be allowed " +
							  "to reset it."
				if(this.state.selected === 1) {
					boxText = "Make sure you choose a strong, but memorable password. " +
							  "Consider having a password over 8 character, and using " +
							  "a mix of uppercase & lowercase characters, digits and  " +
							  "special characters."
				}
				boxContent = (
						<div>
							<p>
								{boxText}
							</p>
						</div>
				);
				compenent = (
					<Aux>
						{this.passwordFieldCompenent()}
						<div>
							<div className={classes.RegisterBox}>
								{boxContent}
							</div>
						</div>
					</Aux>

				);
			}  else  {
				compenent = (
						<a className={classes.Link} href="/profile/">
							Continue
						</a>
				);
			}

			view = (
				<div className={classes.UpdatePassword}>
					<section className={classes.Content}>
						<ProgressHeader 
							num = "3" 
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
					</section>
				</div>
			);
		}
		return(
			<div>
				{view}
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

export default withRouter(UpdatePassword);
