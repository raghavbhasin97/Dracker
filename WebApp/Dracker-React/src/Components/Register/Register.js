import React, { Component } from 'react';
import classes from './Register.css';
import { withRouter } from 'react-router-dom'
import Spinner from '../UI/Spinner/Spinner'
import Backdrop from '../UI/Backdrop/Backdrop'
import Input from '../UI/Input/Input'; 
import { 
		validateEmail, 
		validatePassword, 
		validatePhone,
		validateName,
		validateStreet,
		validateCity,
		validateZip,
		validateBirthdate,
		validateSSN 
		} from '../../Validity'
import ProgressHeader from '../UI/ProgressHeader/ProgressHeader'
import Aux from '../../hoc/Aux/Aux'
import SidebarItem from '../UI/SidebarItem/SidebarItem'
import Money from '../../assests/images/money1.png'
import Bank from '../../assests/images/bank.png'
import Axios from '../../Axios'


const steps = ['Create your account', 'Tell us who you are', 'Confirm your identity', 'Account created']
const states = [
 'AL','AK','AS','AZ','AR','CA','CO','CT','DE','DC','FM','FL','GA',
 'GU','HI','ID','IL','IN','IA','KS','KY','LA','ME','MH','MD','MA',
 'MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND',
 'MP','OH','OK','OR','PW','PA','PR','RI','SC','SD','TN','TX','UT',
 'VT','VI','VA','WA','WV','WI','WY'
];
class Register extends Component {
	state = {
		validity: {
			email: true,
			password: true,
			phone: true,
		},
		selected: 0
	}


	shouldComponentUpdate(nextProps, nextState) {
		return nextState.validity !== this.state.validity || nextState.selected !== this.state.selected || nextState.isLoading !== this.state.isLoading
	}

// Part One of Form
	SubmitAccount = (event) => {
		event.preventDefault()
		const email = event.target.email.value;
		const password = event.target.password.value;
		const phone = event.target.phone.value;
		const vEmail = validateEmail(email)
		const vPassword = validatePassword(password)
		const vPhone = validatePhone(phone)
		if(!vEmail || !vPhone || !vPassword) {
			this.setState({validity: {
				email: vEmail,
				password: vPassword,
				phone: vPhone
			}})
			return
		}
		this.setState({validity: {
			name: true,
			street: true,
			city: true
		}, selected: 1, email: email, password: password, phone: phone});
	} 


	stepOne = () => {
		return (
			<Aux>
				<h1 className={classes.Header}>
					You're on your way to creating a new account.
				</h1>
				<form id="1" onSubmit={this.SubmitAccount}>
					<Input 
						key = "register_email"
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
						key = "register_phone"
						valid = {this.state.validity.phone}
						type = "tel"
						label = "Phone"
						id = "phone"
						name = "phone" 
						autoCapitalize = "off"
						required
						maxLength="10"
						validation = {validatePhone}
						invalidMessage = "Please enter a valid phone number."
					/>
					<Input 
						key = "register_password"
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
					<button className={classes.Button} id="submit">
						Continue
					</button>
				</form>
			</Aux>
		);
	}

//Part two of Form 

	stepTwo = () => {

		return (
			<Aux>
				<h1 className={classes.Header}>
					Enter your personal information to get started.
				</h1>
				<form id="2" onSubmit={this.SubmitPersonal}>
					<Input 
						key = "register_name"
						valid = {this.state.validity.name}
						type = "text"
						label = "Name"
						id = "name"
						name = "name" 
						autoCapitalize = "words"
						required
						validation = {validateName}
						invalidMessage = "Please enter a valid name."
					/>
					<Input 
						key = "register_street"
						valid = {this.state.validity.street}
						type = "text"
						label = "Street Address"
						id = "street"
						name = "street" 
						autoCapitalize = "off"
						required
						maxLength="200"
						validation = {validateStreet}
						invalidMessage = "Please enter a valid address."
					/>
					<Input 
						key = "register_city"
						valid = {this.state.validity.city}
						type = "text"
						label = "City"
						id = "city"
						name = "city" 
						autoCapitalize = "off"
						required
						maxLength="200"
						validation = {validateCity}
						invalidMessage = "Please enter a valid city."
					/>
					<button className={classes.Button} id="submit2">
						Continue
					</button>
				</form>
			</Aux>
		);
	}

	SubmitPersonal = (event) => {
		event.preventDefault()
		const name = event.target.name.value;
		const street = event.target.street.value;
		const city = event.target.city.value;
		const vName = validateName(name)
		const vStreet = validateStreet(street)
		const vCity = validateCity(city)
		if(!vName || !vStreet || !vCity) {
			this.setState({validity: {
				name: vName,
				street: vStreet,
				city: vCity
			}})
			return
		}
		this.setState({validity: {
			zip: true,
			birthdate: true,
			ssn: true
		}, selected: 2, name: name, street: street, city: city, state: states[0]});
	} 

//Part three of Form 

	stateSelected = (event) => {
		this.setState({state: event.target.value})
	}
	stepThree = () => {
		
		return (
			<Aux>
				<h1 className={classes.Header}>
					Enter your identifying information to continue.
				</h1>
				<form id="3" onSubmit={this.SubmitIdentity}>
					<div className={classes.Content}>
						<Input 
							key = "register_zip"
							valid = {this.state.validity.zip}
							type = "text"
							label = "Zip Code"
							id = "zip"
							name = "zip" 
							autoCapitalize = "off"
							required
							maxLength="5"
							validation = {validateZip}
							invalidMessage = "Please enter a valid zip code."
						/>
						&nbsp;&nbsp;
						<div className={classes.Dropdown}>
							<select 
									defaultValue = "State"
									className={classes.DropdownSelector} 
									onChange={this.stateSelected}
							>
								{states.map(state =>{
									return (
										<option key={'state_' + state} value={state}>
											{state}
										</option>
									);
								})}
							</select>
						</div>
					</div>
					<div className={classes.Content}>
						<Input 
							key = "register_birthday"
							valid = {this.state.validity.birthdate}
							type = "date"
							label = "Birthdate"
							id = "birthdate"
							name = "birthdate" 
							autoCapitalize = "off"
							required
							validation = {validateBirthdate}
							invalidMessage = "You must be 18 years of age to register."
						/>
						&nbsp;&nbsp;
						<Input 
							key = "register_ssn"
							valid = {this.state.validity.ssn}
							type = "text"
							label = "Last 4 of SSN"
							id = "ssn"
							name = "ssn" 
							autoCapitalize = "off"
							required
							maxLength="4"
							validation = {validateSSN}
							invalidMessage = "Please enter last 4 of SSN."
						/>
					</div>
					<button className={classes.Button} id="submit3">
						Create Account
					</button>
				</form>
				<div className={classes.ErrorMessage}>
					{this.state.error}
					<a href="/auth/register/" className={classes.Link} style={{fontSize: '16px', display: this.state.error ? 'block' : 'none', textAlign: 'center'}}>
							Restart ?
					</a>
				</div>
			</Aux>
		);
	}

	SubmitIdentity = (event) => {
		event.preventDefault()
		const zip = event.target.zip.value;
		const ssn = event.target.ssn.value;
		const birthdate = event.target.birthdate.value;
		const vZip = validateZip(zip)
		const vSSN = validateSSN(ssn)
		const vBday = validateBirthdate(birthdate)
		if(!vZip || !vSSN || !vBday) {
			this.setState({validity: {
				zip: vZip,
				birthdate: vBday,
				ssn: vSSN
			}})
			return
		}

		this.setState({validity: {
				zip: true,
				birthdate: true,
				ssn: true
		}, isLoading: true, error: null})

		const User = {
			email: this.state.email,
			password: this.state.password,
			phone: this.state.phone,
			name: this.state.name,
			street: this.state.street,
			city: this.state.city,
			state: this.state.state,
			zip: zip,
			ssn: ssn,
			birthdate: birthdate
		}
		console.log(User)
		Axios.post('/users/create', User).then(res =>{
			const message = res.data.message
			let errorMessage = null
			switch(message){
				case 'EMAIL_EXISTS': 
					errorMessage = 'This email address already has a Dracker account associated with it.';
					break;
				case 'PHONE_NUMBER_EXISTS': 
					errorMessage = 'This phone number already has a Dracker account associated with it.';
					break;
				case 'ERROR': 
					errorMessage = 'This phone number already has a Dracker account associated with it.';
					break;
				case 'SUCCESS': 
					errorMessage = null;
					break;
				default:
					errorMessage = 'Something went wrong while trying to register.'
			}

			if(errorMessage === null) {
				this.setState({isLoading: false, validity: null, selected: 3});
			} else {
				this.setState({isLoading: false, error: errorMessage});
			}
		}).catch(err=> {
			this.setState({isLoading: false, error: 'Something went wrong while trying to register.'})
		})
	} 

//Part 4

	stepFour = () => {
		return(
			<Aux>
				<h1 className={classes.Header}>
					Account Created.
				</h1>
				<p className={classes.Description}>
					You have sucessfully registered for Dracker.
					You can now start sending/receiving money with friends
					anywhere anytime. Download the mobile app to stay on top
					of your finances at all times. 
				</p>
				<div className={classes.LoginInfo}>
					Login: {this.state.email}
				</div>
				<div className={classes.Center}>
					<a className={classes.Link} href="/auth/login/">
						Start Dracking
					</a>
				</div>
			</Aux>		
		);
	} 

	render() {

		let displayView = null
		if(this.state.selected === 0) {
			displayView = this.stepOne()
		} else if(this.state.selected === 1) {
			displayView = this.stepTwo()
		} else if(this.state.selected === 2) {
			displayView = this.stepThree()
		} else {
			displayView = this.stepFour()
		}

		if(this.state.selected < 3) {
			displayView = (
				<Aux>
					{displayView}
					<p className={classes.Terms}>
						By clicking on "Continue", you agree to Dracker's Terms Of Service, including our Privacy Policy.
					</p>
				</Aux>
			);
		}

		return(
			<div className={classes.Register}>
				<section className={classes.Section}>
					<ProgressHeader 
						num = "4" 
						steps = {steps}
						selected = {this.state.selected}
					/>
					<div className={classes.Content}>
						<section className={classes.Form}>
							{displayView}
						</section>
						<section className={classes.Sidebar}>
							<SidebarItem 
								key="sidebar_money"
								image={Money}
								header="Transfer Money At A Click"
								description="You can transfer and receive money with friends just using phone number. Dracker is availible on the web and mobile."
							/>
							<SidebarItem 
								key="sidebar_bank"
								image={Bank}
								header="Immediate Access To Funds"
								description="Get immediate access to funds. Money is transfered directly between accounts."
							/>
						</section>
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

}

export default withRouter(Register)