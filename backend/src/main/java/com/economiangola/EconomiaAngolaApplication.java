// src/main/java/com/economiangola/EconomiaAngolaApplication.java
package com.economiangola;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableJpaAuditing
@EnableAsync
public class EconomiaAngolaApplication {

    public static void main(String[] args) {
        SpringApplication.run(EconomiaAngolaApplication.class, args);
    }
}
