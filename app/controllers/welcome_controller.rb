class WelcomeController < ApplicationController
	require 'httparty'
	require 'will_paginate/array'

	def index
		url = 'https://www.gvsu.edu/webteam/sample_129387238476.json'
		response = HTTParty.get(url)
		@organizations = JSON.parse(response.body)
		@categories = Array.new
		@organizations.each do |organization|
			@categories.push(organization['category']['name'])
		end
		@categories = @categories.uniq
	end

	def list
		url = 'https://www.gvsu.edu/webteam/sample_129387238476.json'
		response = HTTParty.get(url)
		@organizations = JSON.parse(response.body)
		@categories = Array.new
		@organizations.each do |organization|
			@categories.push(organization['category']['name'])
		end
		@categories = @categories.uniq

		if params[:category].present?
			@organizations = @organizations.select {|organization| organization['category']['name'] ==  params[:category]}
		end
		if params[:search_term].present?
			@organizations = @organizations.select{ |organization| organization['long_name'].downcase.include? params[:search_term].downcase}
		end
		if params[:keywords].present?
			@organizations = @organizations.select{ |organization| organization['keywords'].downcase.include? params[:keywords].downcase}
		end
		@organizations = @organizations.paginate(:page => params[:page], :per_page => 10)
	end

	def view
		url = 'https://www.gvsu.edu/webteam/sample_129387238476.json'
		response = HTTParty.get(url)
		@organizations = JSON.parse(response.body)
		@organization = @organizations.find {|organization| organization['id'] ==  params[:id].to_i}
	end

	def contact
		url = 'https://www.gvsu.edu/webteam/sample_129387238476.json'
		response = HTTParty.get(url)
		@organizations = JSON.parse(response.body)
		@organization = @organizations.find {|organization| organization['id'] ==  params[:id].to_i}
	end

	def contact_post
		ContactMailer.contact_email(params[:first_name], params[:last_name], params[:subject], params[:message]).deliver_now
		redirect_to welcome_list_path
	end
end