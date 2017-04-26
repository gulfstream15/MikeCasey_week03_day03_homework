require ('pg')
require_relative ('../db/sql_runner.rb')
require_relative('../models/album')

class Artist

  attr_reader :id
  attr_accessor :name

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @name = options['name']
  end

  def save
    sql = "
    INSERT INTO artists (
      name
    ) VALUES (
      '#{ @name }'
    )
    RETURNING id;"

    result = SqlRunner.run(sql)

    result_hash = result.first()
    new_id = result_hash['id']
    @id = new_id.to_i()
  end

  def Artist.all()
    sql = "SELECT * FROM artists;" 
    artist_hashes = SqlRunner.run(sql)
    artist_objects = artist_hashes.map do |artist_hash| 
      Artist.new(artist_hash) 
    end
    return artist_objects
  end

  def Artist.delete_all()
    sql = "DELETE from artists;"
    SqlRunner.run(sql)
  end

  def Artist.find(id)
    sql = "SELECT * FROM artists 
    WHERE id = #{id};"
    results = SqlRunner.run(sql)
    artist_hash = results.first
    artist = Artist.new(artist_hash)
    return artist
  end

  def delete()
    sql = "DELETE FROM artists 
    WHERE id = #{@id};"
    SqlRunner.run(sql)
  end

  def albums()
    sql = "SELECT * FROM albums 
    WHERE artist_id = #{@id};"
    album_hashes = SqlRunner.run(sql)
    album_objects = album_hashes.map do |album_hash| 
      Album.new(album_hash) 
    end
    return album_objects
  end

end
