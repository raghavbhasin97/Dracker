import React, { Component } from 'react';
import classes from './Profile.css'
import { formatPhone, getProfile , getIdentifier} from '../../Formattings'
import BankItem from '../../Components/BankItem/BankItem'
import uuid4 from 'uuid4'
import Axios from '../../Axios'
import Spinner from '../../Components/UI/Spinner/Spinner'
import Backdrop from '../../Components/UI/Backdrop/Backdrop'

class Profile extends Component {
	state = {}
	constructor(props){
		super(props)
		const accountDeatils = JSON.parse(props.User.funding_source)
		const defaultAccount = accountDeatils.default
		let accounts = []
		for(let i = 0; i < accountDeatils.list.length; i++){
			const item = accountDeatils.list[i]
			const isDefault = (item.url === defaultAccount.url);
			
			accounts.push({
				...item,
				default: isDefault
			});
		}
		this.state = {
			email: props.User.email,
			name: props.User.name,
			phone: props.User.phone,
			uid: props.User.uid,
			session: uuid4(),
			accounts: accounts,
			paymentMessage: null,
			displayMessage: false,
			isLoading: false

		}
		localStorage.setItem('session', this.state.session)
	}

	handleChangeDefault = (newUrl) => {
		this.setState({isLoading: true})
		const data = {
			url: newUrl,
			phone: this.state.phone
		}
		Axios.post('/users/bank/default', data).then(res =>{
			if(res.data.message === "SUCCESS") {
				this.setNewDefault(newUrl)
			} else {
				const errorMessage = "There was an error changing the default " +
									 "funding source. The bank account may have " + 
									 "been deleted."
				this.setState({paymentMessage: errorMessage, displayMessage: true, isLoading: false})
			}
		}).catch(err => {
			const errorMessage = "Something went wrong while attempting to change " +
								 "the default funding source. Please make sure you " +
								 "are connected to the internet."
			this.setState({paymentMessage: errorMessage, displayMessage: true, isLoading: false})
		})

	}

	setNewDefault = (newUrl) => {
		let accounts = []
		let newDefault = ""
		for(let i = 0; i < this.state.accounts.length; i++) {
			let newItem = {...this.state.accounts[i]}
			if(newItem.url === newUrl) {
				newItem.default = true;
				newDefault = newItem.name
			} else {
				newItem.default = false;
			}
			accounts.push(newItem)
		}
		const successMessage = "The default funding source " +
								"has been successfully changed to " + 
								newDefault + "."

		this.setState({accounts: accounts, paymentMessage: successMessage, displayMessage: true, isLoading: false})
		setTimeout(() => {
			this.setState({displayMessage: false})
		}, 5000);
	}

	render() {
		const image = getProfile(this.state.uid);
		let bankAccounts = []
		for(let i = 0; i < this.state.accounts.length; i++){
			const item = this.state.accounts[i]
			const key = getIdentifier(item.url)
			bankAccounts.push(<BankItem 
								key = {key} 
								{...item}
								setDefault = {() => this.handleChangeDefault(item.url)}
								/>
			);
		}

		if(bankAccounts.length < 1) {
			bankAccounts = (
						<div className={classes.Empty}>
							<p>
								You haven't attached any funding sources
								to your Dracker account yet.
							</p>
						</div>
					);
		} 
		return(
		    <div className={classes.Profile}>
		    	<div className={classes.Container}>
		    	<section>
				    <h1 className={classes.Heading}>
				      		Profile
				    </h1>
				    <p className={classes.SubHeading}>
				      		Tell us about yourself so we can keep your 
				      		profile up to date and help recommend ways 
				      		for you to optimize your finances in the future.

				    </p>
			    </section>
			    <section className={classes.Section}>
			    	<h1 className={classes.Title}>
			    		Basic Info
			    	</h1>
				    <div className={classes.SectionContainer}>
				    	<img className={classes.Image} src={image} alt={this.state.name + '_Profile'} />
				    	<p className={classes.Name}>
				    		{this.state.name}
				    		<br />
				    		<span className={classes.Deatils}>
					    		<span className={classes.Smaller}>
					    			{this.state.email}
					    			<span>
					    				&nbsp;
					    				(
					    					<a className={classes.Link} href={"/account/update-email/" + this.state.session}>
					    						edit
					    					</a>
					    				)
					    			</span>
					    		</span>
					    		<br />
					    		<span className={classes.Smaller}>
					    			+1 {formatPhone(this.state.phone)}
					    		</span>
					    		<br />
					    		<span className={classes.Smaller}>
					    			*******
					    			<span>
					    				&nbsp;
					    				(
					    					<a className={classes.Link} href={"/account/update-password/" + this.state.session}>
					    						edit
					    					</a>
					    				)
					    			</span>
					    		</span>
					    	</span>
					    </p>
				    </div>
			    </section>
			    <section className={classes.Section}>
			    	<h1 className={classes.Title}>
			    		Funding Sources
			    	</h1>
			    	<div className = {classes.Message}>
			    		<span className={classes.MessageBody} style={{
			    			opacity: this.state.displayMessage? '1' : '0' 
			    		}}>
			    			{this.state.paymentMessage}
			    		</span>
			    	</div>
			    	<div>
			    		{bankAccounts}
			    	</div>
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

export default Profile;

