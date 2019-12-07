
package com.evil;
import java.io.*;
import java.util.concurrent.Semaphore;

public class MatchMaking
{
	private Semaphore sem;
	PrintWriter playerInQ;
	public MatchMaking(){
		sem = new Semaphore(1);
	}
	Player find(PrintWriter p)
	{
		try{
		Game game = new Game(19);
		if(sem.tryAcquire()){
			playerINQ = p;
			sem.acquire();
			sem.release();

		}else{
			return new HumanPlayer(false,game,playerInQ);
		}
		return null;
		}finally{
			sem.release();
		}
	}
}


