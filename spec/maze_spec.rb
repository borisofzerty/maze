require_relative 'spec_helper'

describe Maze do
  describe ".new" do
    context "with a valid filename" do

      it "load well formatted mazes" do
        expect(Maze.new("spec/good.maze").content).to eq (
          [[:wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall],
            [:wall, :from, :free, :free, :free, :free, :free, :wall],
            [:wall, :free, :free, :free, :free, :free, :dest, :wall],
            [:wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall]])
      end

      it "raise exception if maze contain bad chars" do
        expect{Maze.new("spec/bad1.maze")}.to \
          raise_exception(StandardError, /invalid char/)
      end

      it "raise exception if maze is not a rectangle"
    end
  end

  describe "#solve" do
    context "when maze can be solved" do
      it "return number of tiles between A and B" do
        expect(Maze.new("spec/good2.maze").solve).to eq 0
        expect(Maze.new("spec/good.maze").solve).to eq 5
        expect(Maze.new("spec/hard.maze").solve).to eq 98
      end
    end

    context "when maze is not solvable" do
      it "return false" do
        expect(Maze.new("spec/bad2.maze").solve).to eq false
      end
    end
  end
end
