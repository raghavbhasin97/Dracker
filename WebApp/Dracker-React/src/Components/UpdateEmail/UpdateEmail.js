import React, { Component } from 'react';
import classes from './UpdateEmail.css'
import Input from '../UI/Input/Input'
import { validateEmail } from '../../Validity'
import ProgressHeader from '../UI/ProgressHeader/ProgressHeader'
import { withRouter } from 'react-router-dom'
import { getIdentifier } from '../../Formattings'
import Invalid from '../UI/Unavailible/Unavailible'
import Axios from '../../Axios'
import Spinner from '../UI/Spinner/Spinner'
import Backdrop from '../UI/Backdrop/Backdrop'

const steps = ['Enter new email address', 'Check your email']
const headers = ['Change Your Email Address', 'Check your email']
const descriptions = ['To change your email, just enter the new email address you want to use to log into your Dracker account. If this email is different from your current email and valid, we will send a verification link to confirm your new email. You will need to confirm this email to continue using Dracker.',
'We\'ve sent a verification email to your new email address. Please follow the link in email to confirm your new email.'
]

class UpdateEmail extends  Component{


	constructor(props){
		super(props)
		const expectedSession = localStorage.getItem('session')
		const currentSession = getIdentifier(this.props.location.pathname)
		this.state = {
			validity: {
				email: true
			},
			selected: 0,
			email: null,
			validSession: (currentSession === expectedSession && props.current !== null),
			seconds: 5,
			isLoading: false,
			errorMessage: null
		}
	}

	continuePressed = (event) => {
		this.setState({isLoading: true, validity: {email: true}, errorMessage: null})
		event.preventDefault()
		const email = event.target.email.value;
		if(!validateEmail(email) || email === this.props.current) {
			this.setState({validity: {email: false}, isLoading: false})
			return 
		}
		const data = {
			new_email: email,
			old_email: this.props.current
		}
		Axios.post('/users/update/email', data).then(res=>{
			const message = res.data.message;
			if(message === "SUCCESS") {
				this.setState({selected: 1, email: email, isLoading: false})
				this.reduceTime()
			} else {
				let errorMessage = null;
				switch(message) {
					case "EMAIL_EXISTS":
						errorMessage = "This email already has a Dracker account associated with it. Please check the email provided."
						break;
					default:
						errorMessage = "Something went wrong while trying to update your email. Please check the email provided."
				}
				this.setState({errorMessage: errorMessage, isLoading: false})
			}
		}).catch(err => {
			this.setState({errorMessage: "Something went wrong while trying to update your email. Please check the email provided.", isLoading: false})
		})
	}

	reduceTime = () => {
		setTimeout(() =>{
			if(this.state.seconds > 0) {
				this.reduceTime()
			} else {
				localStorage.setItem('session', null)
				this.props.history.push('/auth/logout/')
			}
			this.setState({seconds: this.state.seconds - 1})
		}, 1000)
	}

	emailFieldCompenent = () => {
		return(
			<form onSubmit={(event) => this.continuePressed(event)}>
				<Input 
					key="updateEmail_newEmail"
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
				<div className={classes.ErrorMessage}>
					{this.state.errorMessage}
				</div>
			</form>
		);
	}

	getEmail = (email) => {
		return(
			<div className={classes.Email}>
				{email}
				<br />
				Logging out in {this.state.seconds}
			</div>
		);
	}

	render(){
		let view = <Invalid text="This email update session is invalid or
							has expired. Please go to profile and start over." />
		if(this.state.validSession) {
			let compenent = null;
			let boxContent = null;
			if(this.state.selected === 0) {
				compenent = this.emailFieldCompenent()
				boxContent = (
						<div>
							<p>
								Once you change your email address, 
								you will be logged out in 5 seconds. 
								Make sure double check the email, as 
								you will need to confirm it before you 
								can log back in.
							</p>
						</div>
				);
			} else {
				compenent = this.getEmail(this.state.email)
				boxContent = (
						<div>
							<h2 className={classes.BoxHeader}>
								Didn't get an email?
							</h2>
							<p>
								Check your spam or junk folder and please 
								allow up to five minutes for the email to arrive.
								Please contact support if you need further assistance.
							</p>
						</div>
				);
			}

			view = (
				<div className={classes.UpdateEmail}>
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
		return(
			<div>
				{view}
			</div>
		);
	}
}

export default withRouter(UpdateEmail);
