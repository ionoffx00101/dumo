package com.tobo.dumo.service;

import java.util.List;
import java.util.Map;

public interface DumoService
{
	List<Map<String, Object>> selectWordList(Map<String, Object> map) throws Exception;
}
