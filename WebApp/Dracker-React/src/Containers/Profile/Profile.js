import React, { Component } from 'react';
import classes from './Profile.css';
import { formatPhone, getProfile , getIdentifier} from '../../Formattings';
import BankItem from '../../Components/BankItem/BankItem';
import uuid4 from 'uuid4';
import Axios from '../../Axios';
import Spinner from '../../Components/UI/Spinner/Spinner';
import Backdrop from '../../Components/UI/Backdrop/Backdrop';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import Modal from '../../Components/UI/Modal/Modal';
import uploadFile from '../../S3.js'
import Aux from '../../hoc/Aux/Aux'
import Avatar from '../../assests/images/avatar.png'



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
			profileImage: getProfile(props.User.uid),
			session: uuid4(),
			accounts: accounts,
			paymentMessage: null,
			displayMessage: false,
			isLoading: false,
			updateProfile: false,
			selectedFile: null,
			isUploadingProfile: false,
			uploadError: null,
			avatar: Avatar,

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

	selectFile = (event) => {
		const file = event.target.files[0];
		console.log(file)
		if(file) {
			let reader = new FileReader();
			reader.onload = () => {
				this.setState({selectedFile: file, uploadError: null, avatar: reader.result}) 
			}
			reader.readAsDataURL(file)       
		} else {
			this.setState({selectedFile: null, uploadError: 'Please select a profile image to upload.', avatar: Avatar}) 
		}
	}

	editProfile = () => {
		this.setState({updateProfile: true})
	}

	dissmissEditProfile = (field) => {
		if(!this.state.isUploadingProfile){
			this.setState({isUploadingProfile: false, selectedFile: null, updateProfile: false , avatar: Avatar})
		}
	}

	handleUpload = () => {
		if(this.state.selectedFile) {
			this.setState({isUploadingProfile: true, uploadError: null})
			uploadFile(this.state.uid, this.state.selectedFile).then(res =>{
				setTimeout(() =>{
					this.setState({isUploadingProfile: false, selectedFile: null, updateProfile: false,  profileImage: this.state.avatar , avatar: Avatar})
				}, 2000)
			}).catch(err =>{
				this.setState({
								isUploadingProfile: false, 
								uploadError: 'Oops! It looks like something went wrong while uploading the new profile image.'
							  });
			})
		} else {
			this.setState({uploadError: 'Please select a profile image to upload.'})
		}
	}

	getUploadOptions = () => {
		return(
				<Aux>
					<div className={classes.Close}>
						<FontAwesomeIcon className={classes.CloseIcon} icon="times"  size="lg" onClick={this.dissmissEditProfile}/>
					</div>
					<div>
						<img className = {classes.UploadImage} src={this.state.avatar} alt="Avatar" /> 
					</div>
					<div className={classes.Upload}>
						<input type="file" accept="image/*" onChange={this.selectFile}/>
					</div>
					<div className={classes.ButtonDiv}>
						<button className={classes.Button} onClick={this.handleUpload}>
							Upload
						</button>
					</div>
					<div className={classes.UploadError}>
						{this.state.uploadError}
					</div>
				</Aux>
		);
	}

	render() {
		let uploadProfileChildren = null;
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

		if(this.state.updateProfile) {
			uploadProfileChildren = this.getUploadOptions()
			if(this.state.isUploadingProfile) {
				uploadProfileChildren = <Spinner />
			}
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
				    	<div className={classes.ProfilePic}>
				    		<img className={classes.Image} src={this.state.profileImage} alt={this.state.name + '_Profile'} />
				    		<div className={classes.Edit}>
				    			<div onClick={this.editProfile} className={classes.EditLink}>
				    				  <FontAwesomeIcon icon="camera" color="#ededed" size="2x"/>
				    			</div>
				    		</div>
				    	</div>
				    	<p className={classes.Name}>
				    		{this.state.name}
				    		<br />
				    		<span className={classes.Deatils}>
					    		<span className={classes.Smaller}>
					    			<FontAwesomeIcon icon="envelope" color="#404245" size="1x"/>
					    			&nbsp;
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
					    			<FontAwesomeIcon icon="phone" color="#404245" size="1x"/>
					    			&nbsp;
					    			+1 {formatPhone(this.state.phone)}
					    		</span>
					    		<br />
					    		<span className={classes.Smaller}>
					    			<FontAwesomeIcon icon="unlock" color="#404245" size="1x"/>
					    			&nbsp;
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
				<Modal show = {this.state.updateProfile} clicked = {this.dissmissEditProfile} className={classes.ProfileModal}>
					{uploadProfileChildren}
				</Modal>
		    </div>
		);
	}
}

export default Profile;

