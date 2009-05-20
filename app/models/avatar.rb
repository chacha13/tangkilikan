class Avatar < ActiveRecord::Base
# Image sizes
IMG_SIZE = '"240x300>"'
THUMB_SIZE = '"50x64>"'
# Image directories
URL_STUB = "/images/avatars"
DIRECTORY = File.join("public", "images", "avatars")

  def initialize(user, image = nil)
      @user = user
      @image = image
      Dir.mkdir(DIRECTORY) unless File.directory?(DIRECTORY)
  end

  def exists?
    File.exists?(File.join(DIRECTORY, filename))
  end
    alias exist? exists?

  def url
    "#{URL_STUB}/#{filename}"
   end

  def thumbnail_url
    "#{URL_STUB}/#{thumbnail_name}"
  end
  
  # Save the avatar images.
  def save
    valid_file? and successful_conversion?
  end
 # Remove the avatar from the filesystem.
def delete
  [filename, thumbnail_name].each do |name|
  image = "#{DIRECTORY}/#{name}"
   File.delete(image) if File.exists?(image)
  end
  end 
private
  # Return the filename of the main avatar.
  def filename
    "#{@user.user_name}.png"
  end
# Return the (system-dependent) ImageMagick convert executable.
def convert
  if ENV["OS"] =~ /Windows/
  # Set this to point to the right Windows directory for ImageMagick.
      "C:\\Program Files\\ImageMagick-6.4.5-Q8\\convert"
   else
      "/usr/bin/convert"
    end
end
  # Return the filename of the avatar thumbnail.
  def thumbnail_name
      "#{@user.user_name}_thumbnail.png"
  end  
# Try to resize image file and convert to PNG.
# We use ImageMagick's convert command to ensure sensible image sizes.
  def successful_conversion?
# Prepare the filenames for the conversion.
    source = File.join("tmp", "#{@user.user_name}_full_size")
    full_size = File.join(DIRECTORY, filename)
    thumbnail = File.join(DIRECTORY, thumbnail_name)
# Ensure that small and large images both work by writing to a normal file.
# (Small files show up as StringIO, larger ones as Tempfiles.)
    File.open(source, "wb") { |f| f.write(@image.read) }
     # Convert the files.
  img = system("#{convert} #{source} -resize #{IMG_SIZE} #{full_size}")
  thumb = system("#{convert} #{source} -resize #{THUMB_SIZE} #{thumbnail}")
 File.delete(source) if File.exists?(source)
  # Both conversions must succeed, else it's an error.
  unless img and thumb
    errors.add_to_base("File upload failed. Try a different image?")
    return false
  end
  return true
end
    
# Return true for a valid, nonempty image file.
def valid_file?
# The upload should be nonempty.
  if @image.size.zero?  
      errors.add_to_base("Please enter an image filename")
      return false
  end
    unless @image.content_type =~ /^image/
      errors.add(:image, "is not a recognized format")
    return false
    end
  if @image.size > 1.megabyte
    errors.add(:image, "can't be bigger than 1 megabyte")
  return false
  end
  return true
  end
end
