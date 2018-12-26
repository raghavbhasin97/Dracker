import React, { Component } from 'react';
import Layout from './Components/Layout/Layout'
import { Switch, Route } from 'react-router-dom';
import Home from "./Components/Home/Home"
import Spinner from "./Components/UI/Spinner/Spinner";
import Axios from "./Axios"
import Transaction from "./Components/Transaction/Transaction"
import Unavailible from "./Components/UI/Unavailible/Unavailible"
import Wallet from "./Components/Wallet/Wallet"
import Summary from "./Containers/Summary/Summary"
import RestingSite from './Components/RestingSite/RestingSite'
import Login from './Components/Login/Login'
import Logout from './Components/Logout/Logout'
import PasswordReset from './Components/PasswordReset/PasswordReset'
import Profile from './Containers/Profile/Profile'
import UpdateEmail from './Components/UpdateEmail/UpdateEmail'
import UpdatePassword from './Components/UpdatePassword/UpdatePassword'

class App extends Component {
	state = {}
	
	constructor(props) {
		super(props);
		const isAuthenticated = localStorage.getItem('isAuthenticated')
		let user = null;
		let isAuth = false;
	    if(isAuthenticated === "true") {
	    	const User = localStorage.getItem('User')
	    	isAuth = true;
	    	user = JSON.parse(User)
	    } 
	    this.state = {
	    		userData: null,
	    		summary: null,
				isLoading: false,
				err:false,
				isAuthenticated: isAuth,
				User: user
	    }
	}


	componentDidMount() {
		if(this.state.isAuthenticated){
			this.setState({isLoading: true})
			const path = '/users/' + this.state.User.uid
			Axios.get(path).then(res => {
				const path = '/friends/' + this.state.User.uid
				const data = res.data
				Axios.get(path).then(res2 =>{
					const summaryData = res2.data
					Axios.get('/users', {params: {phone: this.state.User.phone}}).then(res3 =>{
						const User = res3.data
						localStorage.setItem('User', JSON.stringify(User))
						this.setState({isLoading: false, userData: data, summary: summaryData, User: User})
					}).catch(err => {
						this.setState({isLoading: false, err:true})
					})
				}).catch(err =>{
					this.setState({isLoading: false, err:true})
				})
			}).catch(err => {
				this.setState({isLoading: false, err:true})
			})
		}
	}

	render() {
		let view = <Spinner />
		if(this.state.isAuthenticated){
			if(!this.state.isLoading) {
				if(this.state.userData) {
					const unsettled = this.state.userData.unsettled;
					let items = []
					for(let i = 0; i<unsettled.length; i++) {
						const item = unsettled[i];
						items.push(
							<Route 
								exact
								key = {'route_' + item.transaction_id}
								path = {"/transaction/" + item.transaction_id + "/"} 
								render = { () => <Transaction item={item} />}
							/>
						);
					}
					view = (
						<Layout>
							<Switch>
						    	<Route path="/" exact render={
						    		() => <Home unsettled={this.state.userData.unsettled}/>
						    	}/>
						    	<Route path="/wallet/" exact render={
						    		() => <Wallet 
						    					credit = {this.state.userData.credit} 
						    					debit = {this.state.userData.debit}
						    					settled = {this.state.userData.settled}
						    			   />
						    	}/>
						    	{items}
						    	<Route path="/summary/" exact render = {
						    		() => <Summary 
						    					summary = {this.state.summary}
						    				/>
						    	}/>
						    	<Route path="/auth/login/" exact render={
						    		() => <Unavailible text="You are already logged in!!!"/>
						    	}/>
						    	<Route path="/profile/" exact render={
						    		() => <Profile User={this.state.User}/>
						    	}/>
						    	<Route path="/account/update-email"  render={
						    		() => <UpdateEmail current={this.state.User.email}/>
						    	}/>
						    	<Route path="/account/update-password"  render={
						    		() => <UpdatePassword email={this.state.User.email}/>
						    	}/>
						    	<Route path="/auth/logout/" exact component={Logout} />
						    	<Route component={() => <Unavailible text="Oops! It looks like that page doesn't exist"/>} />
							</Switch>
					    </Layout>
					);				
				} else if(this.state.err){
					view = <Unavailible text="Something went wrong."/>
				}
			}
		} else {
			view = (
				<Layout authentication>
					<Switch>
						<Route path="/" exact component={RestingSite} />
						<Route path="/auth/login/" exact component={Login} />
						<Route path = "/auth/account-recovery" exact component={PasswordReset} />
						<Route component={() => <Unavailible text="Oops! It looks like that page doesn't exist"/>} />
					</Switch>
				</Layout>
			);
		}

	    return (
	      <div>
	      	{view}
	      </div>
	    );
	}
}

export default App;
