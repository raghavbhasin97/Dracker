import React, { Component } from 'react';
import classes from './SummaryDetail.css';
import SummaryDetailItem from  './SummaryDetailItem/SummaryDetailItem'


class SummaryDetail extends Component {
	state = {
		pending: true,
		sent: false,
		received: false
	}

	shouldComponentUpdate(nextProps, nextState) {
		return nextState.pending !== this.state.pending || 
			   nextState.sent !== this.state.sent ||
			   nextState.received !== this.state.received
	}

	toggleItems = (item) => {
		switch(item) {
			case 'pending':
					this.setState({pending: true, sent: false, received: false});
					break;
			case 'sent':
					this.setState({pending: false, sent: true, received: false});
					break;
			case 'received':
					this.setState({pending: false, sent: false, received: true});
					break;
			default: 
					this.setState({pending: false, sent: false, received: false});
		}
	}

	render() {
		let items = [];
		const transactions = this.props.transactions
		if(this.state.pending) {
			for(let i = 0; i < transactions.length; i++) {
				const item = transactions[i]
				if(item["time"] !== undefined) {
					items.push(<SummaryDetailItem 
								key = {'pendeing_' + i}
								amount = {item.amount}
								time = {item.time}
								description = {item.description}
								isDebt = {item.is_debt}
								pending
							   />);
				}
			}
			if(items.length < 1) {
				items = (
							<div className={classes.Empty}>
								You have not pending transactions!
							</div>
						);
			} 
		} else if(this.state.sent) {
			for(let i = 0; i < transactions.length; i++) {
				const item = transactions[i]
				if(item["settelement_time"] !== undefined) {
					if(item["is_debt"]){
						items.push(<SummaryDetailItem 
									key = {'pendeing_' + i}
									amount = {item.amount}
									time = {item.settelement_time}
									description = {item.description}
								   />);
					}
				}
			}
			if(items.length < 1) {
				items = (
							<div className={classes.Empty}>
								You haven't Sent any money yet!
							</div>
						);
			} 
		} else if(this.state.received) {
			for(let i = 0; i < transactions.length; i++) {
				const item = transactions[i]
				if(item["settelement_time"] !== undefined) {
					if(!item["is_debt"]){
						items.push(<SummaryDetailItem 
									key = {'pendeing_' + i}
									amount = {item.amount}
									time = {item.settelement_time}
									description = {item.description}
								   />);
					}
				}
			}
			if(items.length < 1) {
				items = (
							<div className={classes.Empty}>
								You haven't Received any money yet!
							</div>
						);
			} 
		}
		return(
				<div className={classes.Summary}>
		      		<div className={classes.Container}>
		      			<button className={classes.Back} onClick={this.props.clicked}> 
		      				&#8249;
		      			</button>
		      			<div className={classes.Heading}>
				      		{this.props.name}
				      	</div>
				      	<div className={classes.Controll}>
				      		<div 
				      			className={this.state.pending ? [classes.Item, classes.Selected].join(' ') : classes.Item} 
				      			onClick={() => this.toggleItems('pending')}>
				      			Pending 
				      		</div>
				      		<div 
				      			className={this.state.sent ? [classes.Item, classes.Selected].join(' ') : classes.Item} 
				      			onClick={() => this.toggleItems('sent')}>
				      			Sent 
				      		</div>
				      		<div 
				      			className={this.state.received ? [classes.Item, classes.Selected].join(' ') : classes.Item} 
				      			onClick={() => this.toggleItems('received')}>
				      			Received 
				      		</div>
				      	</div>
				      	<div className={classes.TransactionsItems}>
				      		{items}
				      	</div>
		      		</div>

		      	</div>
		);
	}
}

export default SummaryDetail;