// src/main/java/com/economiangola/repository/OpcaoRespostaRepository.java
package com.economiangola.repository;

import com.economiangola.domain.entity.OpcaoResposta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OpcaoRespostaRepository extends JpaRepository<OpcaoResposta, Long> {

    List<OpcaoResposta> findByPerguntaIdOrderByOrdemAsc(Long perguntaId);
}
