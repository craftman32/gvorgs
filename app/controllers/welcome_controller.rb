class WelcomeController < ApplicationController
	require 'httparty'
	require 'will_paginate/array'

	url = 'https://www.gvsu.edu/webteam/sample_129387238476.json'
	response = HTTParty.get(url)
	$organizations = JSON.parse(response.body)
	$categories = Array.new
	$organizations.each do |organization|
		$categories.push(organization['category']['name'])
	end
	$categories = $categories.uniq

	def index
	end

	def list
		@organizationsList = $organizations
		if params[:search_term].present?
			@organizationsList = @organizationsList.select{ |organization| organization['long_name'].downcase.include? params[:search_term].strip.downcase}
		end
		if params[:keyword].present?
			@organizationsList = @organizationsList.select{ |organization| organization['keywords'].downcase.include? params[:keyword].strip.downcase}
		end
		if params[:category].present?
			@organizationsList = @organizationsList.select {|organization| organization['category']['name'].include?  params[:category]}
		end
		@organizationsList = @organizationsList.uniq.paginate(:page => params[:page], :per_page => 10)
	end

	def view
		@organization = $organizations.find {|organization| organization['id'] ==  params[:id].to_i}
	end

	def contact
		@organization = $organizations.find {|organization| organization['id'] ==  params[:id].to_i}
	end

	def contact_post
		ContactMailer.contact_email(params[:first_name], params[:last_name], params[:subject], params[:message]).deliver_now
		redirect_to welcome_contact_path(:status => 'contact_post')
	end

	def about
	end
end