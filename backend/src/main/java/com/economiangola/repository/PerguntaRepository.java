// src/main/java/com/economiangola/repository/PerguntaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.Pergunta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PerguntaRepository extends JpaRepository<Pergunta, Long> {

    List<Pergunta> findByQuizIdOrderByOrdemAsc(Long quizId);
}
