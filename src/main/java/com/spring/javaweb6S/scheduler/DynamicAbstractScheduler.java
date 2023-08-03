package com.spring.javaweb6S.scheduler;

import org.springframework.scheduling.Trigger;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

public abstract class DynamicAbstractScheduler {
	private ThreadPoolTaskScheduler scheduler;

	public void stopScheduler() {
		scheduler.shutdown();
	}

	public void startScheduler() {
		scheduler = new ThreadPoolTaskScheduler();
		scheduler.initialize();
		// 스케쥴러가 시작되는 부분
		scheduler.schedule(getRunnable(), getTrigger());
	}

	private Runnable getRunnable() {
		return new Runnable() {
			@Override
			public void run() {
				runner();
			}
		};
	}

	public abstract void runner();

	public abstract Trigger getTrigger();
}
