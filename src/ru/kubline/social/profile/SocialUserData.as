package ru.kubline.social.profile {
import com.adobe.serialization.json.JSONDecoder;

import ru.kubline.controllers.Singletons;

/**
	 * анкета пользователя из социальной сети
	 */ 
	public class SocialUserData	{
		
        private var id:uint = 0;

        private var firstName:String = '';

        private var serverName:String = '';

		private var lastName:String = '';

        private var nickName:String = '';
        
        private var photo:String = 'http://www.vk-footballer.com/Static/content/OTHER/badPlayer.jpg';

        private var photoBig:String = 'http://www.vk-footballer.com/Static/content/OTHER/badPlayer.jpg';

        private var birthday:Date = new Date();

        private var sex:int = -1;
        
        private var country:int = 1;

        private var university:int = 1;

        private var city:int = 1;

        private var countryName:String;

        private var universityName:String;

        private var cityName:String;

        private var userInfo:Object;

		public function SocialUserData() {
			
		}
		
		public function getId():uint {
			return id;
		}
		
		public function getFirstName(forceFromFirstRequest:Boolean = false):String {

            if(forceFromFirstRequest){

                if((firstName == '' && id == Application.teamProfiler.getSocialUserId()) && !userInfo){
                    var firstResponce:Object = new JSONDecoder( Singletons.context.getFlashVars().api_result ).getValue();
                    userInfo = firstResponce.response[0];
                }
                if(userInfo && userInfo.first_name){
                    firstName = userInfo.first_name;
                }
            }
			return firstName;
		}
		
		public function getLastName(forceFromFirstRequest:Boolean = false):String {
            if(forceFromFirstRequest || (lastName == '' && id == Application.teamProfiler.getSocialUserId())){
                if(!userInfo){
                    var firstResponce:Object = new JSONDecoder( Singletons.context.getFlashVars().api_result ).getValue();
                    userInfo = firstResponce.response[0];
                    lastName = userInfo.last_name;
                }
            }
			return lastName;
		}

		public function getServerName():String {
			return serverName;
		}

		public function getNickName():String {
			return nickName; 
		}

		public function getPhoto():String {
            return photo; 
		}

		public function getPhotoBig():String {
			return photoBig;
		}
		
		public function getBirthday():Date {
			return birthday;
		}

		public function getCountry():int {
			return country;
		}

		public function getUniversity():int {
			return university;
		}

		public function getCity():int {
			return city;
		}
		
		public function getSex():int {
			return sex;
		}
		
		public function setId(id:uint): void {
			this.id = id;
		}
		
		public function setFirstName(firstName:String): void {
			this.firstName = firstName;
		}
		
		public function setLastName(lastName:String): void {
			this.lastName = lastName;
		}

		public function setServerName(firstName:String): void {
			this.serverName = firstName;
		}
  
		public function setNickName(nickName:String): void {
			this.nickName = nickName;
		}
  
		public function setPhoto(photo:String): void {
			this.photo = photo;
		}

		public function setPhotoBig(photo:String): void {
			this.photoBig = photo;
		}
		
		public function setBirthday(birthday:Date): void {
			this.birthday = birthday;
		}
		
		public function setSex(sex:int): void {
			this.sex = sex;
		}

		public function setCountry(country:int): void {
			this.country = country;
		}

		public function setCity(city:int): void {
			this.city = city;
		}

		public function setUniversity(university:int): void {
			this.university = university;
		}
		
		public function toString(): String {
            var str:String = getFirstName() + " " + getLastName() + getNickName();
            var len:uint =  str.length;
			return "SocialUserData {" + 
						" id: " + id + ", " + 
						String + "(len: " + len + ")"+
						", sex: " + getSex() + 
						", bDate: " + (getBirthday() ? getBirthday().toLocaleDateString() : null) +
						", photo: " + getPhoto() + 
					" }";
		}

        public function getCountryName():String {
            return countryName;
        }

        public function setCountryName(value:String):void {
            countryName = value;
        }

        public function getUniversityName():String {
            return universityName;
        }

        public function setUniversityName(value:String):void {
            universityName = value;
        }

        public function getCityName():String { 
            return cityName;
        }

        public function setCityName(value:String):void {
            cityName = value;
        }
    }
}