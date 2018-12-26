import React, { Component } from 'react';
import classes from './ProgressHeader.css'

class ProgressHeader extends Component {

	state = {}
	constructor(props) {
	  super(props);
	  this.state = {
	  		selected: props.selected
	  };
	}

	componentWillReceiveProps(props) {
	 	this.setState({selected: props.selected})
	}

	render() {
		let items = []
		const widthPerItem = 100/this.props.num;
		let style = {width: widthPerItem + '%'}
		let progressStyle = {...style,
			marginLeft: (widthPerItem * (this.state.selected)) + '%'
		}
		for(let i = 0; i < this.props.num; i++) {
			const description = this.props.steps[i]
			let attachedClasses = [classes.Item]
			if(i === this.state.selected) {
				attachedClasses.push(classes.Active)
			}
			items.push(
						<div 
							key={i}
							className={attachedClasses.join(' ')} style={style}>
							{'Step' + (i + 1)}
							<br/ >
							{description}
						</div>
			);
		}

		return(
			<div>
				<div className={classes.ItemsContainer}>
					{items}
				</div>
				<div className={classes.Progress}> 
					<div className={classes.Filled} style={progressStyle}>
					</div>
				</div>
			</div>
		);
	}
}

export default ProgressHeader;