package com.tobo.dumo.vo;

public class WordVO
{
	private int word_index;
	private String word;
	private String wordCheck;

	public int getWord_index()
	{
		return word_index;
	}

	public void setWord_index(int word_index)
	{
		this.word_index = word_index;
	}

	public String getWord()
	{
		return word;
	}

	public void setWord(String word)
	{
		this.word = word;
	}

	public String getWordCheck()
	{
		return wordCheck;
	}

	public void setWordCheck(String wordCheck)
	{
		this.wordCheck = wordCheck;
	}

	@Override
	public String toString()
	{
		return "WordVO [word_index=" + word_index + ", word=" + word + ", wordCheck=" + wordCheck + "]";
	}
}
