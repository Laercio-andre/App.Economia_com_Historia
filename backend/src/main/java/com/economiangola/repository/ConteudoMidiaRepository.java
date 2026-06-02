// src/main/java/com/economiangola/repository/ConteudoMidiaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.ConteudoMidia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConteudoMidiaRepository extends JpaRepository<ConteudoMidia, Long> {

    List<ConteudoMidia> findByConteudoIdOrderByOrdemAsc(Long conteudoId);
}
