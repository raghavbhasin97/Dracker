import React, { Component } from 'react';
import classes from './Summary.css'
import SummaryItem from './SummaryItem/SummaryItem'
import SummaryDetail from '../SummaryDetail/SummaryDetail'

class Summary extends Component {

	state = {
		showingComponent: false,
		component: null
	}


	showDetails = (item) => {
		const component = <SummaryDetail 
								clicked = {this.hideDetails}
								name = {item.name}
								transactions = {item.transactions}
						   />
		this.setState({showingComponent: true, component: component})
	}

	hideDetails = () => {
		this.setState({showingComponent: false, component: null})
	}

	render() {
		let view = null;
		if(this.state.showingComponent) {
			view = this.state.component
		} else {
			let feed = Object.keys(this.props.summary).map(ikey =>{
						const item = this.props.summary[ikey]
						return <SummaryItem 
									key = {'summaryitem_' + ikey}
									name = {item.name}
									uid = {ikey}
									phone = {item.phone}
									amount = {item.amount}
									clicked = {() => this.showDetails(item)}
								/>
					});	
					if(feed.length < 1) {
						feed = (
								<div className={classes.Empty}>
									<p>
										You haven't started any transactions
										on Dracker yet. Get started any You
										can see a summary here.
									</p>
								</div>
						);
					} 
					view = (
					    <div className={classes.Summary}>
					    	<div className={classes.Container}>
						    	<section>
								    <h1 className={classes.Heading}>
								      		Summary
								    </h1>
								    <p className={classes.SubHeading}>
								      		A look at your dracking history.
								      		This provides you a look at your 
								      		dracking summary with your friends, 
								      		a snapshot of how much you owe them
								      		or they owe you, and all your Dracker
								      		transactions in the past.

								    </p>
							    </section>
						      	{feed}
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

export default Summary;